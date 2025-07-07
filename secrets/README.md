# Secrets Management

## Encrypting a new secret:

1. Place the plain secret file where you want it.
1. Add the plain secret file to `.gitignore`.
1. Update `config.yaml` with where to encrypt and decrypt the secret.
1. Ensure the encrypted version of the secret does not exist, as the script does not overwrite it.
1. Run `./install encrypt`.

## Updating a secret

1. Update the plain secret file
1. Delete the encrypted version of the secret, as the script does not overwrite it.
1. Run `./install encrypt`.

## Installing a secret

1. Run `./install` like normal.

## Deleting a secret

1. Delete the plain secret and encrypted secret.
1. Remove the secret from `config.yaml`.
1. Remove the secret from `.gitignore`.
