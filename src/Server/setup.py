from setuptools import setup, find_packages

# Read contents from your requirements.txt file
with open('./receipt_server/requirements.txt') as f:
    required_packages = f.read().splitlines()

setup(
    name='receiptExtractor',
    version='0.1',
    packages=find_packages(),
    install_requires=required_packages
)