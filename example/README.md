## Example using lambda-packs for classification model on aws lambda

1. extract the content of `../packs/libs.zip` and paste them in `iris_project/functions/train`
2. cd iris_project, edit `project.json` and set your aws role with right permissions
3. use this command to deploy `apex deploy` [apex.run](http://apex.run/)
4. test the function with this command `echo -n '{ "body": {"ops": "train"} }' | apex invoke train`