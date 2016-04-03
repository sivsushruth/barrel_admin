# barrel_futon


Futon interface for barrel.

## Installation

add this application to the barrel release. add the following to the ini file
under the `[httpd_global_handlers]` section:

```
_utils = {barrel_httpd_futon, handle_req}
```
