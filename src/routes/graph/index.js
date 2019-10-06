const express = require('express');
const graphqlHTTP = require('express-graphql');
import config from './config';
import schema from './schema';

const { graphql:
    {
        ide,
        pretty
    },
    graphqlEndpoint
} = config;

const app = express.Router();
console.info('GRAPHQL STARTING...');
app.use(graphqlEndpoint, (req, res) => {
    graphqlHTTP({
        schema,
        graphiql: ide,
        pretty,
        formatError: function (err) {
            return err.message
        }
    })(req, res)
})

export default app;

