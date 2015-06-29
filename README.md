# ci

## Building the image

    docker build -t stijn/php2 .

## Preparing the container

    docker run -v /home/smu/code/ci/www:/srv/http/ --name lamp2 -p 80:80 -d stijn/php2

## Troubleshooting

    docker exec -it lamp2 bash

## Running test

    ruby runner.rb


