import {
  GraphQLList,
  GraphQLInt,
  GraphQLString,
  GraphQLObjectType,
  GraphQLBoolean,
  GraphQLFloat,
} from 'graphql';
import { updateStatus, updateExchangeRate, updateComission, resetGame } from './resolvers';


const queries = {},
  mutations = {};

const SuccessResponse = new GraphQLObjectType({
  name: 'successResponse',
  description: 'successResponse',
  fields: function () {
    return {
      success: {
        type: GraphQLBoolean
      }
    }
  }
})

mutations.resetValues = {
  type: SuccessResponse,
  resolve: resetGame
}

mutations.changeComission = {
  type: SuccessResponse,
  args: {
    comission: {
      type: GraphQLFloat
    }
  },
  resolve: updateComission
}

mutations.changeExchangeRate = {
  type: SuccessResponse,
  args: {
    exchangeRate: {
      type: GraphQLFloat
    }
  },
  resolve: updateExchangeRate
}

mutations.changeStatus = {
  type: SuccessResponse,
  args: {
    status: {
      type: GraphQLString
    }
  },
  resolve: updateStatus
}


export {
  queries,
  mutations
}