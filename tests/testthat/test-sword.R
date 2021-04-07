test_that("sword-dag-diag", {

  load("./test-sword.RData")

  sword_out <- sword(repo = ".", dir = ".")

  expect_equal(sword_out, sword_demo)

  expect_length(sword_out, 8)
})
