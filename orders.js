router.get("/fetch-orders/:sortType", CheckAuth, async (req, res) => {
  const orders = await Orders.find({ _id: req.user._id });

  switch (req.params.sortType) {
    case "big-price":
      orders.sort((a, b) => {
        return b.price - a.price;
      });
      res.json(orders);
      break;

    case "new-to-old":
      orders.sort((a, b) => {
        return b.date - a.date;
      });
      res.json(orders);
      break;

    case "old-to-new":
      orders.sort((a, b) => {
        return a.date - b.date;
      });
      res.json(orders);
      break;

    default:
      orders.sort((a, b) => {
        return b.price - a.price;
      });
      res.json(orders);
      break;
  }
});
