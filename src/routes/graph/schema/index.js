import {
    GraphQLSchema,
    GraphQLObjectType
} from 'graphql';

import {
    queries as usersQueries,
    mutations as userMutations
} from './users';
import {
    queries as stocksQueries,
    mutations as stocksMutations
} from './stocks';
import {
    queries as stockPriceQueries,
    mutations as stockPriceMutation
} from './stock_price';
import {
    queries as holdingsQueries,
    mutations as holdingsMutation
} from './holdings';
import {
    queries as transactionsQueries,
    mutations as transactionsMutation
} from './transactions';




// console.log(customerQueries)
const query = new GraphQLObjectType({
    name: 'query',
    description: 'All the methods to read data ',
    fields: () => ({
        ...usersQueries,
        ...stocksQueries,
        ...stockPriceQueries,
        ...holdingsQueries,
        ...transactionsQueries
    })
})

const mutation = new GraphQLObjectType({
    name: 'mutations',
    description: 'All the methods to create, modify of create data',
    fields: () => ({
        ...transactionsMutation,
    })
})

const schema = new GraphQLSchema({
    query,
    mutation
})

export default schema;