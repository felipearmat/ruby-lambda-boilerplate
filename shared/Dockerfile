FROM public.ecr.aws/lambda/ruby:2.7 as final

# Install system build dependencies
RUN yum install -y make
RUN yum install -y gcc
RUN yum install -y amazon-linux-extras
RUN amazon-linux-extras enable postgresql14
RUN yum install -y postgresql-devel

ENV LAYER_FOLDER=shared

ADD ${LAYER_FOLDER}/Gemfile .

RUN bundle install

# ADD functions functions
ADD ${LAYER_FOLDER} ./

ARG FUNCTION_FOLDER=functions
ADD ${FUNCTION_FOLDER} ./

RUN mkdir /opt/ruby && cd /opt/ruby && ln -s ./${LAYER_FOLDER} lib

# ADD spec spec
ADD template_dev.yaml .

# Command can be overwritten by providing a different command in the template directly.
CMD ["app.LambdaHandler.handle"]
