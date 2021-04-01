atreplinit() do repl
    try
        @eval using Revise
        @async Revise.wait_steal_repl_backend()
    catch
    end
end

ENV["JULIA_EDITOR"] = "code --wait"
# ENV["JULIA_PARDISO"] = "/Users/spech/lib/"
# ENV["SCALAPACK_PREFIX"] = "/usr/local/opt/brewsci-scalapack"
# ENV["PYTHON"] = "python3"
