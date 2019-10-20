import {
  GraphQLObjectType,
  GraphQLFloat,
  GraphQLString
} from 'graphql';

export default new GraphQLObjectType({
  name: 'params',
  description: 'params',
  fields: function () {
    return {
      comission: {
        type: GraphQLFloat
      },
      exchangeRate: {
        type: GraphQLFloat
      },
      status: {
        type: GraphQLString
      }
    }
  }
});