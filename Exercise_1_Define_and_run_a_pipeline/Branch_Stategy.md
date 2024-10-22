# Branch-Strategie für das Projekt


Die Branch-Strategie soll sicherstellen, dass der Code stabil, produktionsbereit und von hoher Qualität ist. Durch den Einsatz verschiedener Branches wird die Entwicklung neuer Funktionen und das Management von Releases optimiert.

## Überblick
Diese Branch-Strategie ermöglicht, dass der Code kontinuierlich getestet und validiert wird, während gleichzeitig die Flexibilität für die Implementierung neuer Funktionen und das Management von Releases erhalten bleibt. Durch den Einsatz von Feature Branches, einem geschützten Master Branch und einem Release Branche, wird die Stabilität und Qualität des Projekts gefördert. Außerdem wird sichergestellt, dass bei dem Mergen in den Release-Branch ein geprüftes Artefakt erstellt und bereitgestellt wird.


## Branch-Typen und Vorgehensweise

### Feature Branches
- Entwickler arbeiten an neuen Funktionen in separaten Feature Branches.
- Die Benennung der Branches erfolgt nach der jeweiligen Funktionalität oder anhand der Tickets (z.B. `feature/user-auth`, `feature/payment-integration`,`Ticket-120-user-auth`).
- **Merge in den Master**:
  - Der Merge erfolgt nur, wenn alle automatisierten Tests und Builds erfolgreich durchlaufen (Continuous Integration - CI).
  - Die CI-Pipeline wird dabei nur ausgelöst, wenn ein Pull Request für den Feature Branch erstellt oder aktualisiert wird.
  - Der Merge wird manuell von einem Reviewer durchgeführt, um die Qualität und den Standard des Codes sicherzustellen.

### Master Branch
- Der Master Branch ist als „protected“ markiert, was bedeutet, dass direktes Pushen nicht erlaubt ist.
- Neue Commits können nur durch das Mergen von Feature Branches in den Master Branch erfolgen.
- Der Master Branch bleibt dadurch immer produktionsbereit (production ready) und enthält nur validierten Code, was die Stabilität des Codes gewährleistet.

### Release Branches oder Tags
- Release Branches werden verwendet, um zwischen dem Hauptentwicklungscode (master) und dem stabilen veröffentlichten Produktionscode zu unterscheiden.
- Wird der Code nach erfolgreichem Review in den Release Branch gemerged, wird eine **Release-Stage** der Pipeline ausgelöst.
- Diese Release-Stage veröffentlicht ein neues Release des Projekts und erstellt ein Artefakt, das z.B. als ausführbare Datei oder Archiv heruntergeladen werden kann.
- Diese Trennung erlaubt eine kontrollierte und strategische Entscheidung, wann neue Features oder ganze Sets von Funktionen tatsächlich in die Produktion übergehen.