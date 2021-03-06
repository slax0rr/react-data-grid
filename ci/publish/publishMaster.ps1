Write-Host "Merging to master. Attempting to bump version"
git config --global credential.helper store
git config --global push.default simple
Add-Content "$env:USERPROFILE\.git-credentials" "https://$($env:access_token):x-oauth-basic@github.com`n"
git config --global user.name $env:APPVEYOR_REPO_COMMIT_AUTHOR
git config --global user.email $env:APPVEYOR_REPO_COMMIT_AUTHOR_EMAIL
git checkout master

if($?)
{
  ./node_modules/.bin/lerna publish --message "Version bump [ci skip]" --yes 
  if($?){
    Write-Host "regenerating public site and examples"
    node ./ci/publish/publishExamples.js
  }
}

exit $lastexitcode
