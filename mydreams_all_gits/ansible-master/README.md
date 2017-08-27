# Provisioning

```bash
ansible-playbook -i hosts playbook.yml
```

# Deploy

```bash
ansible-playbook -i hosts deploy_production.yml
ansible-playbook -i hosts deploy_staging.yml
```

# Rollback

```bash
ansible-playbook -i hosts rollback_production.yml
ansible-playbook -i hosts rollback_staging.yml
```
