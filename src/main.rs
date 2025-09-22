use markdown;
use maud::*;
use serde_derive::Deserialize;
use std::env;
use std::fs;
use std::fs::File;
use std::io::prelude::*;
use std::path::PathBuf;
use toml;
use walkdir::{DirEntry, WalkDir};

#[derive(Deserialize)]
struct Metadata {
    name: String,
    framework: String,
}

fn generate_page(md: &str, data: Metadata) -> String {
    return html! ({
        head {
            title { (data.name) }
            link rel="stylesheet" href=(data.framework);
        }
        html {
            body {
                header {
                    h1 { (data.name) }
                }
                main {
                    (PreEscaped(markdown::to_html(md)))
                }
            }

        }
    })
    .into_string();
}

fn main() {
    let args: Vec<String> = env::args().collect();
    fn is_toml(entry: &DirEntry) -> bool {
        entry
            .file_name()
            .to_str()
            .map(|s| s.ends_with(".toml"))
            .unwrap_or(false)
    }
    let md_dir = WalkDir::new(&args[1]).into_iter();
    for entry in md_dir.filter_entry(|e| !is_toml(e)) {
        if entry.as_ref().unwrap().path().is_dir() {
            let entry_path = entry.unwrap();
            println!("{}", entry_path.path().display());
            std::fs::create_dir_all(
                args[2].to_owned()
                    + "/"
                    + &entry_path.path().display().to_string()
                        [args[1].to_string().len()..entry_path.path().display().to_string().len()],
            );
        } else {
            let entry_path = entry.unwrap();
            println!("{}", entry_path.path().display());
            let metadata_path = entry_path.path().display().to_string() + ".toml";
            let contents = fs::read_to_string(entry_path.path());
            let metadata_contents = fs::read_to_string(metadata_path);
            let index: Metadata = toml::from_str(metadata_contents.unwrap().as_ref()).unwrap();
            let mut html_path: PathBuf = PathBuf::from(
                args[2].to_owned()
                    + "/"
                    + &entry_path.path().display().to_string()
                        [args[1].to_string().len()..entry_path.path().display().to_string().len()],
            );
            html_path.set_extension("html");
            let mut html_file = File::create_new(&html_path).unwrap();
            html_file.write_all(&generate_page(contents.unwrap().as_ref(), index).into_bytes());
        }
    }
}
