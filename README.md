# polyclass
a docker to classify FaceBook posts

## STarting a project to analyze OPs and analyze trends

## To run
docker run --rm -e ANTHROPIC_API_KEY=sk-ant-... political-classifier

## The run line
docker run --rm \
  -e ANTHROPIC_API_KEY=sk-ant-... \
  -v "$(pwd)/data:/data" \
  political-classifier \
  --input posts.csv --text-col text --id-col post_id --output results.csv
