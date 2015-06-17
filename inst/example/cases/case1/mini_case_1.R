output$mc1_profit <- renderPlot({
  Price <- seq(0,12,.1)
  b <- 10
  Profit <- -b * Price^2 + 120 * Price - 200
  dat <- data.frame(Price = Price, Profit = Profit)

  p <- input$price
  prof <- -b * p^2 + 120 * p - 200

  ggplot(dat, aes(x = Price, y = Profit)) +
    geom_line() +
    coord_fixed(ratio = 0.015, xlim = c(0, 12), ylim = c(-200, 200)) +
    geom_vline(xintercept = p, linetype = "dashed") +
    geom_hline(yintercept = prof, linetype = "dotted") +
    geom_point(x = p, y = prof, size = 8, color = "chocolate", alpha = 0.6) +
    annotate("text", x = 14, y = 115, label = paste0("Profit: $", prof)) +
    annotate("text", x = 6, y = 10, label = paste0("Profit: $", prof))
})

make_quiz("1.01", "At what price would Icekimo sell 75 cups?",
          paste0("$",c("2.00","2.50","3.00","3.50","4.00")),
          "$2.50", "At a price of $2.50 demand would be 100 - 10 x 2.50 = 75",
          "In the equation above replace the 0 by 75 and solve for p")

make_quiz("1.02", "If Iceskimo sold 80 units at a price of $10, what must the price sensitivity have been in the Kearny Mesa market?",
          c("-1","-2","-3","-4","-5"),
          "-2",
          "With a price sensitivity of -2, the demand would be 100 - 2 x 10 = 80",
          "In the equation above replace s(p) by 80 and p by 10 and solve for *a* in 80 = 100 - a x 10")

make_quiz("1.03", "At what price would Iceskimo sell nothing if the price sensitivity were equal to -8?",
          paste0("$",c("11.00","11.50","12.00","12.50","13.00")),
          "$12.50",
          "With a price sensitivity of -8 and a price of 12.5, the demand would be 100 - 8 x 12.5 = 0",
          "In the equation above calculate s(p) by plugging in the price sensitivity and price")

make_quiz("1.04", "At what price are profits maximized?",
          paste0("$",c("4.00","5.00","6.00","7.00","8.00")),
          "$6.00",
          "Adjust the price slider and you will obtain the largest profit of $160 at the price $6.00",
          "Adjust the price slider and compare the profit")

make_quiz("1.05", "What are the profits generated at a price of $5.50?",
          paste0("$",c("150.00","152.50","155.00","157.50","160.00")),
          "$157.50",
          "Replace the price \\(p\\) with 5.5 in the profit function and we can obtain (100 - 10 x 5.5) x (5.5 - 2) = 157.5",
          "Replace the price \\(p\\) with 5.5 in the profit function")

output$mini_case_1 <- renderUI({
  tagList(
    inclRmd("./cases/case1/01_introduction.Rmd"),
    uiOutput("quiz_1.01"),
    uiOutput("quiz_1.02"),
    uiOutput("quiz_1.03"),
    sliderInput("price", label = "Adjust price:", min = 0, max = 12,
                value = state_init("price", 3), step = 1),
    plotOutput("mc1_profit"),
    inclRmd("./cases/case1/04_profit_max.Rmd"),
    uiOutput("quiz_1.04"),
    uiOutput("quiz_1.05")
  )
})
