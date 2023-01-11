docker run \
    --rm \
    --volume "$(pwd)/:/src" \
    --workdir "/src/" \
    swift:5.7.1-amazonlinux2 \
    swift build --product OpenAILambda -c release -Xswiftc -static-stdlib
