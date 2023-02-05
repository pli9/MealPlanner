# ui ####
ui <- dashboardPage(
    # Dashboard Header
    dashboardHeader(
        # Creating Title
        title = tagList(
            # Title when sidebar is expanded
            span(class = "logo-lg", "Meal Planner"), 
            # Title when sidebar is collapsed
            'MP'
        )
    ),
    # Dashboard Sidebar
    dashboardSidebar(
        sidebarMenu(id = 'tabs',
                    menuItem('Planner', tabName = 'planner', icon = icon('bullseye')),
                    menuItem('Shopping List', tabName = 'shoppinglist', icon = icon('bullseye')),
                    menuItem('Recipes', tabName = 'recipes', icon = icon('bullseye')),
                    menuItem('Add a Recipe', tabName = 'addarecipe', icon = icon('bullseye'))
        )
    ),
    # Dashboard Body
    dashboardBody(
        tags$head(
            tags$link(rel = "stylesheet", type = "text/css", href = "treasury.css?version=1")
        ),
        tabItems(
            # Planner
            tabItem(
                tabName = 'planner',
                column(
                    width = 12,
                    fluidRow(
                        box(
                            id = 'planner',
                            width = 12,
                            title = 'Weekly Meal Planner',
                            uiOutput('sunMealPlan'), uiOutput('monMealPlan'), uiOutput('tueMealPlan'), uiOutput('wedMealPlan'), uiOutput('thuMealPlan'), uiOutput('friMealPlan'), uiOutput('satMealPlan'),
                            column(
                                width = 12,
                                fluidRow(
                                    useSweetAlert(),
                                    column(
                                        width = 4,
                                        fluidRow(
                                            actionButton(
                                                inputId = 'savePlanAction',
                                                label = 'Save',
                                                width = '100%'
                                            )
                                        )
                                    ),
                                    column(
                                        width = 4,
                                        fluidRow(
                                            actionButton(
                                                inputId = 'clearPlanAction',
                                                label = 'Clear',
                                                width = '100%'
                                            )
                                        )
                                    ),
                                    column(
                                        width = 4,
                                        fluidRow(
                                            actionButton(
                                                inputId = 'randomPlanAction',
                                                label = 'Random',
                                                width = '100%'
                                            )
                                        )
                                    )
                                )
                                
                            )
                        )
                    )
                )
            ),
            # Shopping List ####
            tabItem(
                tabName = 'shoppinglist',
                column(
                    width = 12,
                    fluidRow(
                        column(
                            width = 6,
                            actionButton(
                                inputId = 'importMealPlan',
                                label = 'Import Current Meal Plan',
                                width = '100%'
                            )
                        ),
                        column(
                            width = 6,
                            actionButton(
                                inputId = 'saveShoppingList',
                                label = 'Save Shopping List',
                                width = '100%'
                            )
                        )
                    ),
                    fluidRow(
                        DTOutput('shoppingListDT')
                    )
                )
            ),
            # Recipes ####
            tabItem(
                tabName = 'recipes',
                column(
                    width = 12,
                    fluidRow(
                        DTOutput('recipesDT')
                    )
                )
            )
        )
    )
)