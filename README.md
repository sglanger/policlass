# polyclass
a docker to classify FaceBook posts

## STarting a project to analyze OPs and analyze trends

## To run
docker run --rm -e ANTHROPIC_API_KEY=sk-ant-... political-classifier

## Runtime options
* API key: It’s passed at runtime with -e and never baked into the image. You can also use --env-file .env.
* User: The container runs as a non-root user.
* Entrypoint: The script is the entrypoint, so everything after the image name goes straight to its flags. With no arguments it runs --demo.
* Model: To change it, add -e CLASSIFIER_MODEL=claude-sonnet-5-5 or use --model.

## The run line
docker run --rm \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -v "$(pwd)/data:/data" \
  political-classifier \
  --input posts.csv --text-col text --id-col post_id --output results.csv
