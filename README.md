# Global gems Bundler Plugin

Include gems in your Ruby projects without adding them to version control.

## Install

Run the following command in your project directory to install locally or in your home directory to install everywhere.

```
bundle plugin install --git=https://github.com/farkasmate/bundler-plugin-global_gems.git global_gems
```

## Usage example

*Include pry in all of your projects.*

Install `pry`:
```
gem install pry
```

**~/.Gemfile.global**:
```
source 'https://rubygems.org'

gem 'pry'
```

**my-project/Gemfile**:
```
source 'https://rubygems.org'

gem 'rake'
```

List gems:
```
bundle global_gems exec gem list

*** LOCAL GEMS ***

bundler (2.0.1)
coderay (1.1.2)
method_source (0.9.2)
pry (0.12.2)
rake (12.3.3)
```

Include global gems by default:
```
alias bundle='bundle global_gems'
```
