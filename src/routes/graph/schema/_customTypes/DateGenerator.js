import {
    GraphQLString,
} from 'graphql'
import moment from 'moment';

export default (variableName) => ({
    type: GraphQLString,
    description: 'Allows to receive a determinated date from database and a format it.',
    args: {
        format: {
            type: GraphQLString,
            description: 'Moment sintaxis like DD/MM/YYYY. If not provided will return the date as unix time.'
        }
    },
    resolve: (obj, args) => {
        if (!obj[variableName]) {
            return ''
        }

        let unixVal = parseInt(obj[variableName])
        let date = null
        if (unixVal > 0) {
            date = new Date(unixVal).getTime()
        } else {
            date = obj[variableName].getTime() / 1000
        }
        if (args.format) {
            return moment.unix(date).format(args.format)
        }
        return date
    }
})