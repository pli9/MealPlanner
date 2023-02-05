server <- function(input, output, session) {
    data.re <- reactiveValues()
    data.re$CurrentPlan <- read_sheet(data.url, 'CurrentPlan') %>%
        as.data.table()
    data.re$RecipeList <- read_sheet(data.url, 'RecipeList') %>%
        as.data.table()
    data.re$Ingredients <- read_sheet(data.url, 'Ingredients') %>%
        as.data.table()
    data.re$Instructions <- read_sheet(data.url, 'Instructions') %>%
        as.data.table()
    
    # Planner ####
    pickerInputforPlanner <- function(day) {
        RecipeList.pickerInput <- lapply(data.re$RecipeList$Recipe_ID,function(x) x)
        names(RecipeList.pickerInput) <- data.re$RecipeList$Name
        
        pickerInput(
            inputId = paste0(substr(day, 1, 3) %>% tolower(), 'MealPlan'),
            label = day,
            choices = RecipeList.pickerInput,
            choicesOpt = list(
                subtext = data.re$RecipeList$Tags
            ),
            selected = data.re$CurrentPlan[Day == day, Recipe_ID],
            options = list(
                `live-search` = TRUE
            )
        )
    }
    output$sunMealPlan <- renderUI({pickerInputforPlanner('Sunday')})
    output$monMealPlan <- renderUI({pickerInputforPlanner('Monday')})
    output$tueMealPlan <- renderUI({pickerInputforPlanner('Tuesday')})
    output$wedMealPlan <- renderUI({pickerInputforPlanner('Wednesday')})
    output$thuMealPlan <- renderUI({pickerInputforPlanner('Thursday')})
    output$friMealPlan <- renderUI({pickerInputforPlanner('Friday')})
    output$satMealPlan <- renderUI({pickerInputforPlanner('Saturday')})
    
    observeEvent(input$savePlanAction, {
        confirmSweetAlert(
            session = session,
            inputId = "confirmSavePlanAction",
            title = "Are you sure you want to save this plan?"
        )
    })
    observeEvent(input$confirmSavePlanAction, {
        if(input$confirmSavePlanAction == TRUE) {
            # Save Stuff
            output <- data.table(
                Day = c('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'),
                Recipe_ID = c(input$sunMealPlan, input$monMealPlan, input$tueMealPlan, input$wedMealPlan, input$thuMealPlan, input$friMealPlan, input$satMealPlan)
            )
            write_sheet(output, data.url, 'CurrentPlan')
        }
    })
    
    observeEvent(input$clearPlanAction, {
        confirmSweetAlert(
            session = session,
            inputId = "confirmClearPlanAction",
            title = "Are you sure you want clear current plan?"
        )
    })
    observeEvent(input$confirmClearPlanAction, {
        if(input$confirmClearPlanAction == TRUE) {
            for(day in c('sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat')) {
                updatePickerInput(
                    session, 
                    inputId = paste0(day, 'MealPlan'),
                    selected = 0
                )
            }
        }
    })
    
    observeEvent(input$randomPlanAction, {
        confirmSweetAlert(
            session = session,
            inputId = "confirmrandomPlanAction",
            title = "Are you sure you want to random plan?"
        )
    })
    observeEvent(input$confirmrandomPlanAction, {
        if(input$confirmrandomPlanAction == TRUE) {
            Recipe_IDs <- sample(data.re$RecipeList[Recipe_ID != 0]$Recipe_ID, 7)
            days <- c('sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat')
            for(i in 1:7) {
                updatePickerInput(
                    session, 
                    inputId = paste0(days[i], 'MealPlan'),
                    selected = Recipe_IDs[i]
                )
            }
        }
    })
    
    # Ingredients List ####
    data.re$ShoppingList <- read_sheet(data.url, 'ShoppingList') %>%
                as.data.table()
    
    observeEvent(input$importMealPlan, {
        meals <- c(input$sunMealPlan, input$monMealPlan, input$tueMealPlan, input$wedMealPlan, input$thuMealPlan, input$friMealPlan, input$satMealPlan)
        meals <- unique(meals)
        new.data.ShoppingList <- data.re$Ingredients %>%
            .[Recipe_ID %in% meals] %>%
            .[, .(Amount = sum(Amount)), by = .(Category, Ingredient, Unit)] %>%
            setorder(Category, Ingredient) %>%
            setcolorder(c('Category', 'Ingredient', 'Amount', 'Unit'))
        data.re$ShoppingList <- new.data.ShoppingList
    })
    observeEvent(input$saveShoppingList, {
        confirmSweetAlert(
            session = session,
            inputId = "confirmsaveShoppingList",
            title = "Are you sure you want to save this shopping list? This will overwrite the current shopping list."
        )
    })
    observeEvent(input$confirmsaveShoppingList, {
        if(input$confirmsaveShoppingList == TRUE) {
            write_sheet(data.re$ShoppingList, data.url, 'ShoppingList')
        }
    })
    output$shoppingListDT <- renderDT({
        data <- data.re$ShoppingList

        datatable(
            data = data,
            options = list(
                autoWidth = TRUE,
                dom = 'Bfrtip',
                ordering = TRUE,
                paging = FALSE,
                searching = FALSE,
                info = FALSE
            ),
            rownames = FALSE
        )
    })
    
    # Recipes ####
    output$recipesDT <- renderDT({
        data <- copy(data.re$RecipeList)
        data[, Recipe_ID := NULL]
        data[, Link := paste0("<a href='",Link,"' target='_blank'>",Link,"</a>")]
        datatable(
            data = data,
            options = list(
                autoWidth = TRUE,
                dom = 'Bfrtip',
                ordering = TRUE,
                paging = FALSE,
                searching = TRUE,
                info = FALSE
            ),
            filter = 'top',
            rownames = FALSE,
            escape = FALSE
        )
    })
    
}