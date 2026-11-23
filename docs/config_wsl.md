Dans PowerShell administrateur :

```powershell
wsl --install -d Ubuntu-24.04
wsl --update
wsl --set-default-version 2
```

Redémarrez si demandé, créez votre utilisateur Ubuntu, puis vérifiez :

```powershell
wsl -l -v
```

Dans Docker Desktop :

- Activez `Use the WSL 2 based engine`.
- Dans `Resources > WSL Integration`, activez `Ubuntu-24.04`.

Ne réinstallez pas de pilote NVIDIA Linux dans Ubuntu WSL.


Créez `%UserProfile%\.wslconfig` :

```ini
[wsl2]
memory=xxGB
processors=yy
swap=10GB
localhostForwarding=true
defaultVhdSize=30000000000
```

Adaptez ces valeurs à votre machine : ne donnez pas toute la RAM à WSL, Windows doit rester confortable. Appliquez ensuite :

```powershell
wsl --shutdown
# ou pour supprimer
# wsl --unregister Ubuntu-24.04
```

** WSL dans VSCODE **

* ajouter l'**extension WSL de microsoft**
* chercher `ctr + shift + P` : connect to WSL
* trouver le dossier windows à partir de `/mnt/c/...`

* OU application WSL et dedans `code`
