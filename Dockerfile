# syntax=docker/dockerfile:1
# Inherit official Python Docker template
FROM python:3.8-slim-buster

# For Flask applications
EXPOSE 5000

WORKDIR /app

# For Python in general
COPY /app/require.txt require.txt
RUN pip3 install -r require.txt --no-cache-dir
# For example, modules needed for the program.
RUN python3 -m pip install matplotlib
# For MLOps, note that better collectively RUN all the commands with && as separator.
RUN apt update && \
    apt install --no-install-recommends -y build-essential gcc && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY ./app .

# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# Need this when docker run with iteractive TTY mode (-it)
RUN adduser --uid 5678 --disabled-password --gecos "" appuser && chown -R appuser /app
USER appuser

CMD ["python3", "-m" , "flask", "run", "--host=0.0.0.0"]
# specify the --host to make sure we can curl the output from our terminal.

# ENTRYPOINT ["python3", "-m" , "flask", "run", "--host=0.0.0.0"]

# The main purpose of a CMD is to provide defaults for an executing container.
# These defaults can include an executable, or they can omit the executable, where you must also specify an ENTRYPOINT instruction.
# ENTRYPOINT should be defined when using the container as an executable.
# If CMD is used to provide default arguments for the ENTRYPOINT instruction, both CMD and ENTRYPOINT should be specified.
# Command line arguments to $docker run will be appended after all elements in an exec form ENTRYPOINT, and will override CMD.
#
# You can use the exec form of ENTRYPOINT to set fairly stable default commands and arguments
# Then use either form of CMD to set additional defaults that are more likely to be changed.

# HOW TO BUILD
# docker build ./path_of_Dockerfile -t Repo-name:My.tag 
# CHECK IMAGE NAME
# docker images
# RUN A CONTAINER
# docker run -d -p 3000:5000 --name my-contain Repo-name:My.tag
# Run in detached (-d) mode so we continue at WSL terminal, -p to specify 3000 as the actual output port from default 5000.
# CHECK STATUS
# docker ps -a
# DIVE INTO the container for terminal dump
# docker attach my-contain
# LEAVE the container
# Ctrl+P, and then right away Ctrl+Q. Escape sequence is read and you are back to WSL.
# STOP EXECUTION AND REMOVE CONTAINER before running edited and updated source codes.
# docker stop my-contain docker rm my-contain