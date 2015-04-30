# origin_auto complete
auto complete script for origin commands https://github.com/openshift/origin

## How to generate the auto complete script for origin command
```bash
  bash generator.sh <command> <output_file_name>
```
  for example:
```
  bash generator.sh openshift autocomplete
  bash generator.sh osc autocomplete
  bash generator.sh osadm autocomplate
  ...
```

## How to use the autocomplete
```
  source <autocomplete file>
```
