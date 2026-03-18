FROM postman/newman

RUN npm install -g newman-reporter-html

WORKDIR /etc/newman



# ENTRYPOINT ["sh","run-tests.sh"]