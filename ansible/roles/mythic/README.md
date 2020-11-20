Role Name
=========

This role will deploy the [Mythic](https://github.com/its-a-feature/Mythic) post-exploit red teaming framework to the target server.

Requirements
------------

Modify the configuration file in `files/config.json` to customize the Mythic deployment, such as specifying the admin username and password.

Role Variables
--------------

N/A

Dependencies
------------

N/A

Example Playbook
----------------

```yaml
---
- hosts: server
  roles:
    - mythic
```

License
-------

MIT

Author Information
------------------

@0xdeadbeefJERKY
https://0xdeadbeefjerky.com