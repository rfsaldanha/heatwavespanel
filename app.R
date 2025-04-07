# Packages
library(shiny)
library(bslib)
library(rpcdas)
library(dplyr)
library(lubridate)
library(vchartr)

# Municipality codes
# mun_names <- geobr::read_municipality() |>
#   sf::st_drop_geometry() |>
#   tidyr::as_tibble() |>
#   dplyr::select(-code_state)
# saveRDS(mun_names, "data/mun_names.rds")

mun_names <- readRDS("data/mun_names.rds")
mun_list <- mun_names$code_muni
names(mun_list) <- paste(mun_names$name_muni, "-", mun_names$abbrev_state)
rm(mun_names)

# Interface
ui <- page_navbar(
  title = "Heatwaves",
  theme = bs_theme(bootswatch = "shiny"),

  # Logo
  tags$head(
    tags$script(
      HTML(
        '$(document).ready(function() {
             $(".navbar .container-fluid")
               .append("<img id = \'logo\' src=\'logo.svg\' align=\'right\' height = \'45.0px\'>"  );
            });'
      )
    ),
    tags$style(
      HTML(
        '@media (max-width:992px) { #logo { position: fixed; right: 10%; top: 0.5%; }}'
      )
    )
  ),

  # Translation
  tags$script(
    HTML(
      "
      $(document).ready(function() {
        // Change the text 'Expand' in all tooltips
        $('.card.bslib-card bslib-tooltip > div').each(function() {
          if ($(this).text().includes('Expand')) {
            $(this).text('Expandir');
          }
        });
  
        // Use MutationObserver to change the text 'Close'
        var observer = new MutationObserver(function(mutations) {
          $('.bslib-full-screen-exit').each(function() {
            if ($(this).html().includes('Close')) {
              $(this).html($(this).html().replace('Close', 'Fechar'));
            }
          });
        });
  
        // Observe all elements with the class 'card bslib-card'
        $('.card.bslib-card').each(function() {
          observer.observe(this, { 
            attributes: true, 
            attributeFilter: ['data-full-screen'] 
          });
        });
      });
    "
    )
  ),

  # Map page
  nav_panel(
    title = "Página A",

    # Sidebar
    layout_sidebar(
      sidebar = sidebar(
        selectizeInput(inputId = "sel_mun", label = "Município", choices = NULL)
      ),

      # Card
      card(
        full_screen = TRUE,
        card_body(
          class = "p-0" # Fill card, used for maps
        )
      )
    )
  ),

  # Graphs page
  nav_panel(
    title = "Página B",

    layout_sidebar(
      sidebar = sidebar(),

      # Graphs card
      card(
        full_screen = TRUE,
        card_header("Card header"),
        card_body()
      )
    )
  ),

  # About page
  nav_panel(
    title = "Página B",
    card(
      card_header("Card title"),
      p("Bla bla bla.")
    ),
    accordion(
      multiple = FALSE,
      accordion_panel(
        "Título A",
        p("Bla bla bla.")
      ),
      accordion_panel(
        "Título B",
        p("Bla bla bla.")
      ),
      accordion_panel(
        "Título C",
        p("Bla bla bla.")
      )
    )
  )
)

# Server
server <- function(input, output, session) {
  # Fill municipality selector
  updateSelectizeInput(
    session = session,
    inputId = "sel_mun",
    server = TRUE,
    choices = mun_list
  )
}

shinyApp(ui, server)
