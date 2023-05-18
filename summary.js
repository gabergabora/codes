//order summary
exports.orderSumaryAdmin = async (req, res, next) => {

    try {

        const orders = await Order.aggregate([
            {
                $group: {
                    _id: null,
                    nbOrders: { $sum: 1 },
                    totalSales: { $sum: '$totalPrice' },
                },
            },
        ]);

        const users = await User.aggregate([
            {
                $group: {
                    _id: null,
                    nbUsers: { $sum: 1 }
                },
            },
        ]);

        const daylyOrders = await Order.aggregate([
            {
                $group: {
                    _id: { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } },
                    orders: { $sum: 1 },
                    sales: { $sum: '$totalPrice' }
                },
            },
        ]);

        res.status(200).json({
            success: true,
            orders,
            users,
            daylyOrders

        })
        next();
    } catch (error) {
        return next(error);
        console.log(error);
    }
}
