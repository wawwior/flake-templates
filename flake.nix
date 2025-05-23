{
  outputs =
    { self }:
    {
      templates = {
        rust = {
          path = ./rust;
          description = "Rust Template";
        };
        rust-lib = {
          path = ./rust-lib;
          description = "Rust Template";
        };
      };
    };
}
