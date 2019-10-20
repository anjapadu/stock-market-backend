import models from '@models';


export async function fetchHoldings({ uuid } = {}, { user_uuid }, _, __) {
    try {
        return await models.holdings.findAll({
            where: {
                user_uuid: uuid || user_uuid
            }
        });
    } catch (e) {
        console.log(e);
    }
}
