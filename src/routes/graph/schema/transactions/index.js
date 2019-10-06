import {
  GraphQLList,
  GraphQLInt,
  GraphQLNonNull,
  GraphQLString,
  GraphQLBoolean
} from 'graphql';
import TransactionType from './typeDef';
import {
  fetchTransactions,
  createTransaction
} from './resolvers';

const queries = {},
  mutations = {};


queries.transactions = {
  type: GraphQLList(TransactionType),
  description: 'To login to the dashboard',
  args: {
    user_uuid: {
      type: GraphQLNonNull(GraphQLString),
      description: 'User name. In this case is an email.'
    }
  },
  resolve: fetchTransactions
}

// queries.users = {
//     type: GraphQLList(UserType),
//     description: 'List all users in the system',
//     resolve: fetchUsers
// }



/*********************/

mutations.buyOrSell = {
  type: TransactionType,
  description: 'Allows to create a transaction to buy or sell actions',
  args: {
    user_uuid: {
      type: GraphQLString,
    },
    stock_uuid: {
      type: GraphQLString,
    },
    stock_price_uuid: {
      type: GraphQLString,
    },
    is_buy: {
      type: GraphQLBoolean
    },
    quantity: {
      type: GraphQLInt
    }
  },
  resolve: createTransaction
}



export {
  queries,
  mutations
}   