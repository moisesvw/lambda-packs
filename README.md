## Lambda Packs

This repo contains Docker image from AWS Linux to compile python 3.6 libraries needed
in AWS Lambda.

### Folders
- Build
   It is used to build dependencies with awslambda docker image
- Packs
  Contains the packages generated inside the docker image
- Dockerfile
  The image used to build dependencies

docker build . --tag awslambda:latest

### Docker commands

Building the docker images usually require it only once:
    `docker build . --tag awslambda:latest`

To run the image you need to specify the build directory and pack directory
    `docker run -rm -v $(pwd)/build:/build -v $(pwd)/packs:/packs -it awslambda:latest`

### Inspired from this posts
 - https://gist.github.com/niranjv/f80fc1f488afc49845e2ff3d5df7f83b
 - https://blog.orikami.nl/building-scipy-pandas-and-numpy-for-aws-lambda-python-3-6-cba9355b44e9


## Tutorial

After build the docker image on Docker commands section run this command 

1. Run docker image to generate libraries

`$ docker run --rm -v $(pwd)/build:/build -v $(pwd)/packs:/packs -it awslambda:latest`

2. Get into workspace and create a virtual environment

```sh
cd /build
rm -rf *
mkdir lambdapack

python3.6 -m venv --copies lambda_build
source lambda_build/bin/activate
```
3. install packages you need in your lambda function

```
pip3.6 install --upgrade pip wheel
pip3.6 install numpy numpy -U
pip3.6 install pandas pandas -U
pip3.6 install scikit-learn scikit-learn -U
```

3. [a] Optional, if for some reason you need postgres or mongodb capabilities in your lambda use this

```sh
pip3.6 install sqlalchemy sqlalchemy -U
pip3.6 install pymongo pymongo -U
cp -R /psycopg2-2.6.1/build/lib.linux-x86_64-3.6/psycopg2 $VIRTUAL_ENV/lib/python3.6/site-packages/psycopg2
```

4. Copy packages into packs directory

```sh
cd /packs
cp -R $VIRTUAL_ENV/lib/python3.6/site-packages/* .
cp -R $VIRTUAL_ENV/lib64/python3.6/site-packages/* .
```

5. Remove not needed files

```sh
find . -type d -name "tests" -exec rm -rf {} +
find -name "*.so" | xargs strip
find -name "*.so.*" | xargs strip
rm -r pip*
rm -r wheel*
rm easy_install.py
find . -name \*.pyc -delete
find . -name \*.txt -delete
```

After this steps you will have the packs you need in packs directory.