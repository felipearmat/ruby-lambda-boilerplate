FROM public.ecr.aws/lambda/ruby:2.7

# Install system build dependencies
RUN yum install -y make
RUN yum install -y gcc
RUN yum install -y amazon-linux-extras
RUN amazon-linux-extras enable postgresql14
RUN yum install -y postgresql-devel

# Receive the arg LAYER_FOLDER from template.yaml, defaults to 'shared'
ARG LAYER_FOLDER=shared

# Add Gemfile and install gems
ADD ${LAYER_FOLDER}/Gemfile ${LAMBDA_TASK_ROOT}
RUN bundle install

# Add layer folder to lambda runtime lib folder
ADD ${LAYER_FOLDER} ${LAMBDA_RUNTIME_DIR}/lib

# Receive the arg FUNCTION_FOLDER from template.yaml, defaults to 'functions'
ARG FUNCTION_FOLDER=functions

# Add function folder to lambda task folder
ADD ${FUNCTION_FOLDER} ${LAMBDA_TASK_ROOT}

# Receive the arg TEMPLATE from template.yaml, defaults to template_dev.yaml
ARG TEMPLATE=template_dev.yaml

# Add template to lambda task folder
ADD ${TEMPLATE} ${LAMBDA_TASK_ROOT}

# Command can be overwritten by providing a different command in the template directly.
CMD ["app.LambdaHandler.handle"]
