# How to contribute

## Issues

1. Issues aus Redmine aussuchen
2. Verständnis ergänzen und mit anderen Mitgliedern absprechen
3. Auf den master wechseln
```
    git checkout master && git pull
```
4. Neue Branch erstellen
```
    git branch 987/TICKET-NAME
```
5. Auf dem localen Rechner die Branch wechseln
```
    git checkout 987/TICKET-NAME
```
6. Issue bearbeiten, Commits erstellen und Branch hochladen
```
    git add .
```
```
    git commit -m "TOLLE AENDERUNG"
```

7. Hochladen un Merge Request erstellen
```
    git push
```
Und im merge request im gitlab erstellen.
8. Issue auf Review stellen und warten
9. Über die Merge Request auf Gitlab unterhalten und ausbessern (eventuell Commits rückgängig machen und ausgebessert neu Hochladen)
10. Anschließend wird die Branch gerebased und in den Master gemerged

Vielen Dank für die Mitarbeit :)
