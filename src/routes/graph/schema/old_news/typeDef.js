import {
  GraphQLObjectType,
  GraphQLString,
  GraphQLInt,
  GraphQLList
} from 'graphql';

export default new GraphQLObjectType({
  name: 'OldNews',
  description: 'OldNews',
  fields: function () {
    return {
      new: {
        type: GraphQLString,
      },
      stockUUID: {
        type: GraphQLString
      }
    }
  }
})