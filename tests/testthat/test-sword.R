test_that("sword-dag-diag", {

  sword_out <- sword(repo = ".", dir = ".")

  expect_length(sword_out, 8)

})
