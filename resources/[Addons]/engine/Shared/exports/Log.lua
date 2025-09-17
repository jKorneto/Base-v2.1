exports("Info", function(message, ...)
    Shared.Log:Info(message, ...);
end);

exports("Debug", function(message, ...)
    Shared.Log:Debug(message, ...);
end);

exports("Warn", function(message, ...)
    Shared.Log:Warn(message, ...);
end);

exports("Error", function(message, ...)
    Shared.Log:Error(message, ...);
end);

exports("Success", function(message, ...)
    Shared.Log:Success(message, ...);
end);