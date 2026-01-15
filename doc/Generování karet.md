# Generování karet


## Použití
Makefile vám usnadní generování karet z XML souborů.
`make help` zobrazí dostupné cíle.

Pro vygenerování černo-bílých karet spusťte:
```bash
make
```

Generování HTML s kartami (líc+rub) lze příkazem:
```bash
make html
```

Vygenerovat PDF s kartami (líc+rub) lze příkazem:
```bash
make pdf
```

`xml` pipeline:
```txt
make pdf -> html -> merge -> validate -> cards/*xml
```