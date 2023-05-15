// getting all queries with filters, sort & pagination
ProductRouter.get("/", async (req, res) => {
  const {
    product_type,
    category,
    sort,
    brand,
    min,
    max,
    tag_list,
    limit = 12,
    page = 1,
    order,
  } = req.query;
  const filter = {};
  if (product_type) filter.product_type = product_type;
  if (category) filter.category = category;
  if (brand) filter.brand = brand;
  if (tag_list) filter.tag_list = tag_list;
  if (min || max) {
    filter.price = {};
    if (min) filter.price.$gte = min;
    if (max) filter.price.$lte = max;
  }

  try {
    let query = ProductModel.find(filter);
    // it will sort price (String) lexicographically so .colleation is used.
    if (sort)
      query = query
        .sort({ [sort]: order })
        .collation({ locale: "en_US", numericOrdering: true });
    if (limit) query = query.limit(Number(limit));
    if (page) query = query.skip(Number(page - 1) * Number(limit));
    const data = await query.exec();
    res.send(data);
  } catch (err) {
    res.status(500).send(err);
  }
});
