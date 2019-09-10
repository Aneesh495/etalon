"""
setup.py: Setup configuration for pyetalon.

Copyright (c) 2026 Aneesh Krishna. All rights reserved.
Distributed under the MIT License.
"""

from setuptools import setup, find_packages

setup(
    name="pyetalon",
    version="1.0.0",
    description="Python bindings and CLI for the Etalon Optical Transport Network Engine",
    author="Aneesh Krishna",
    packages=find_packages(),
    entry_points={
        "console_scripts": [
            "etalon-cli = pyetalon.cli:main",
        ],
    },
)
