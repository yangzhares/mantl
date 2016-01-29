#!/usr/bin/python
# -*- coding: utf-8 -*-

DOCUMENTATION = """
---
module: rpmver
short_description: check, compare and assert versions of rpm packages (and also running kernel)
options:
  package:
    required: no
  version:
    required: no
  kernel:
    required: no
  assert:
    required: no
"""

from ctypes import CDLL, c_char_p
from ctypes.util import find_library
from functools import cmp_to_key
import operator
import subprocess
import os

from ansible.module_utils.basic import *  # noqa

ops = {
  "==": "eq",
  "<=": "le",
  "<": "lt",
  ">": "gt",
  ">=": "ge",
}

_rpm = CDLL(find_library("rpm"))
def _rpmvercmp(a, b):
    return _rpm.rpmvercmp(c_char_p(a), c_char_p(b))

version = cmp_to_key(_rpmvercmp)

def op2func(op):
    fn = ops.get(op, None)
    if not fn and op in ops.values():
       fn = op
    return getattr(operator, fn)

def rpm_package_version(pkg):
    return subprocess.check_output(["rpm", "-q", "-qf", "%{version}", pkg])

def kern():
    return os.uname()[2]

def main():

    module = AnsibleModule(
        argument_spec= {
            "package": dict(type='str'),
            "version": dict(type='str'),
            "kernel": dict(type='str'),
            "assert": dict(type='str', choices=ops.keys() + ops.values()),
        },
	required_one_of = [['package', 'kernel'], ['version', 'kernel']],
        required_together = [['package', 'version']]
    )
    package = module.params['package']
    requestedVersion = module.params['version']
    kernel = module.params['kernel']
    assertCondition =module.params['assert']
    
    if kernel:
        requestedVersion = kernel
        installedVersion = kern()
        package = "KERNEL"
    else:
        installedVersion = rpm_package_version(package)

    reply = {
        'version': installedVersion,
        'package': package,
    }
   
    if assertCondition:
        if op2func(assertCondition)(version(installedVersion), version(requestedVersion)):
            module.exit_json(changed=False)
        else:
            module.fail_json(msg="Version condition not met:  {installed} {op} {requested}".format(installed=installedVersion, op=assertCondition, requested=requestedVersion))
    else:
        module.exit_json(changed=True, version=reply)

if __name__ == '__main__':
    main()
