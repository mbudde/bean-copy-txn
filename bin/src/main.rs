use std::path::Path;

use anyhow::{anyhow, Context, Result};

use beancount_core as bc;
use beancount_parser::parse;


fn main() -> Result<()> {
    let filename = std::env::args().nth(1).ok_or(anyhow!("Filename argument required"))?;
    let line = std::env::args().nth(2).and_then(|s| s.parse().ok());

    let id = std::cell::Cell::new(0);
    print_transactions(Path::new(&filename), line, &id)
}

fn print_transactions(filename: &Path, tx_id: Option<usize>, id: &std::cell::Cell<usize>) -> Result<()> {
    let unparsed_file = std::fs::read_to_string(filename)
            .with_context(|| format!("Failed to read Beancount file {}", filename.display()))?;
    let ledger = parse(&unparsed_file)?;
    for dir in ledger.directives {
        match dir {
            bc::Directive::Transaction(tx) => {
                if let Some(src) = tx.source {
                    if let Some(tx_id) = tx_id {
                        if id.get() == tx_id {
                            print!("{}", src);
                            std::process::exit(0);
                        }
                    } else {
                        let desc = match tx.payee {
                            Some(p) => format!("\"{}\" \"{}\"", p, tx.narration),
                            None => format!("\"{}\"", tx.narration)
                        };
                        println!("{} {} * {}", id.get(), &tx.date, desc);
                    }
                }
                id.set(id.get() + 1);
            }
            bc::Directive::Include(include_dir) => {
                let mut path = Path::new(filename).to_path_buf();
                path.pop();
                path.push(&*include_dir.filename);
                let path = path.canonicalize().context("Could not canonicalize include path")?;
                print_transactions(&path, tx_id, id)?;
            }
            _ => {}
        }
    }

    Ok(())
}
