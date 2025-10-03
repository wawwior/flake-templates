{
  outputs =
    { ... }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "Rust Template";
        };
      };
    };
}
