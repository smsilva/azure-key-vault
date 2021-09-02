# Azure Key Vault

## Create Resources

- Key Vault
- Key Vault Access Policies

## Purge Azure Key Vault Soft Deleted

```
WARNING: Running the script below will PURGE and PERMANENT DELETE any previously deleted Azure Key Vault on the actual Subscription. Be careful.
```

```bash
while read -r AZURE_KEY_VAULT_NAME; do
  if [ -n "${AZURE_KEY_VAULT_NAME}" ]; then
    echo "${AZURE_KEY_VAULT_NAME}"
    az keyvault purge -n ${AZURE_KEY_VAULT_NAME}
    echo ""
  fi
done <<< "$(az keyvault list-deleted --resource-type vault --output tsv --query '[].name')"
```

Note: if you get the error `"(MethodNotAllowed) Operation 'DeletedVaultPurge' is not allowed."` as explained [here](https://stackoverflow.com/a/64094916/6406538):

> _"The reason is that you have enabled the **Purge protection** when you create the keyvault._
>
> _**Once the Purge protection is enabled, it's not allowed to delete it**. Please refer to the doc for more details. I just pasted part of the doc as below:_
>
> _**When purge protection is turned on**, a **vault** or an **object** in deleted state **cannot be purged until the retention period has passed**._
>
> _And please also note that, **if the Purge protection is enabled**, **you cannot disable it**._
>
> _So during creating the key vault, please make sure the Purge protection is disabled, then try the command again."_
