iZeyy = {}

local main_menu = RageUI.AddMenu("", "Faites vos actions")

local Questions = {
    { 
        question = "Quel est la limite de vitesse en ville ?", 
        choices = {"50 km/h", "70 km/h", "90 km/h"}, 
        correctAnswer = 1
    },
    { 
        question = "Que signifie un feu rouge ?", 
        choices = {"Arrêt", "Ralentir", "Accélérer"}, 
        correctAnswer = 1 
    },
    { 
        question = "Que faire en cas de pluie ?", 
        choices = {"Accélérer", "Maintenir la vitesse", "Ralentir"}, 
        correctAnswer = 3 
    },
    { 
        question = "Âge minimum pour passer le permis ?", 
        choices = {"16 ans", "18 ans", "20 ans"}, 
        correctAnswer = 2
    },
    { 
        question = "Quelle est la priorité à une intersection ?", 
        choices = {"Voiture venant de gauche", "Voiture venant de droite", "Voiture tout droit"}, 
        correctAnswer = 2 
    }
}

local currentQuestionIndex = 1
local selectedAnswers = {}

function iZeyy:OpenCodeMenu()
    main_menu:Toggle()
end

main_menu:IsVisible(function(Items)
    if currentQuestionIndex <= #Questions then
        local currentQuestion = Questions[currentQuestionIndex]
        
        Items:Separator(currentQuestion.question)
        Items:Line()
        
        for i, choice in ipairs(currentQuestion.choices) do
            Items:Button(choice, nil, {RightBadge = selectedAnswers[currentQuestionIndex] == i and RageUI.BadgeStyle.Tick or nil}, true, {
                onSelected = function()
                    selectedAnswers[currentQuestionIndex] = i
                end
            })
        end
        
        Items:Line()
        Items:Button("Valider la reponse", nil, {}, true, {
            onSelected = function()
                if currentQuestionIndex < #Questions then
                    currentQuestionIndex = currentQuestionIndex + 1
                else
                    RageUI.CloseAll()
                    iZeyy:ShowResults()
                end
            end
        })
    else
        Items:Separator("Aucune question restante")
    end
end)

function iZeyy:ShowResults()
    local correctCount = 0
    local totalQuestions = #Questions
    local maxErrorsAllowed = 2

    for i, question in ipairs(Questions) do
        if selectedAnswers[i] == question.correctAnswer then
            correctCount = correctCount + 1
        end
    end

    local errorsCount = totalQuestions - correctCount

    if errorsCount <= maxErrorsAllowed then
        ESX.ShowNotification(("Félicitations ! Vous avez réussi le test avec un score de %d bonnes réponses sur %d."):format(correctCount, totalQuestions))
        TriggerServerEvent("iZeyy:DrivingSchool:AddDmv", "code")
    else
        ESX.ShowNotification(("Malheureusement ! Vous avez raté le test avec un score de %d bonnes réponses sur %d."):format(correctCount, totalQuestions))
    end
    iZeyy:ResetQuiz()
end

function iZeyy:ResetQuiz()
    currentQuestionIndex = 1
    selectedAnswers = {}
end
