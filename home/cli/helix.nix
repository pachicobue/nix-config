{
  pkgs,
  ...
}:
{
  programs.helix = {
    enable = true;
    extraPackages = with pkgs; [
      clang-tools
      vscode-langservers-extracted
      lua-language-server
      markdown-oxide
      nil
      nixfmt-rfc-style
      taplo
      pkgs.rust-analyzer
      pkgs.rustfmt
      pkgs.lsp-ai
    ];
    themes = {
      catppuccin_transparent = {
        "inherits" = "catppuccin_mocha";
        "ui.background" = "none";
      };
    };
    settings = {
      theme = "catppuccin_transparent";
      editor = {
        middle-click-paste = false;
        bufferline = "always";
        color-modes = true;
        true-color = true;
        undercurl = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        whitespace.render = {
          space = "none";
          nbsp = "all";
          nnbsp = "all";
          tab = "all";
          newline = "none";
          tabpad = "none";
        };
        indent-guides.render = true;
      };
      keys = {
        insert = {
          C-q = ":o ~/lsp-ai-chat.md";
          C-x = {
            C-s = ":write";
            k = ":buffer-close";
          };
          j.k = "normal_mode";
        };
        normal = {
          C-q = ":o ~/lsp-ai-chat.md";
          C-tab = ":buffer-next";
          C-x = {
            C-s = ":write";
            k = ":buffer-close";
          };
          H = ":buffer-previous";
          L = ":buffer-next";
          space = {
            w = ":write";
            W = ":write-all";
            f = "file_picker";
            F = "file_picker_in_current_directory";
            "." = "file_picker_in_current_buffer_directory";
            x = ":buffer-close";
            X = ":buffer-close!";
            o = ":buffer-close-others";
            O = ":buffer-close-others!";
            q = ":quit";
            Q = ":quit!";
            "space" = "command_mode";
          };
        };
      };
    };
    languages = {
      language-server = {
        lsp-ai = {
          command = "lsp-ai";
          config = {
            memory.file_store = { };
            models.model1 = {
              type = "anthropic";
              chat_endpoint = "https://api.anthropic.com/v1/messages";
              model = "claude-3-haiku-20240307";
              # model = "claude-3-5-sonnet-20240620";
              auth_token_env_var_name = "ANTHROPIC_API_KEY";
            };
            chat = [
              {
                trigger = "!C";
                action_display_name = "Chat";
                model = "model1";
                parameters = {
                  max_context = 4096;
                  max_tokens = 1024;
                  system = ''You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately'';
                };
              }
              {
                trigger = "!CC";
                action_display_name = "Chat with context";
                model = "model1";
                parameters = {
                  max_context = 4096;
                  max_tokens = 1024;
                  system = ''
                    You are a code assistant chatbot. The user will ask you for assistance coding and you will do you best to answer succinctly and accurately given the code context:

                    {CONTEXT}
                  '';
                };
              }
            ];
            actions = [
              {
                action_display_name = "Complete";
                model = "model1";
                parameters = {
                  max_context = 4096;
                  max_tokens = 1024;
                  system = ''
                    You are an AI coding assistant. Your task is to complete code snippets. The user's cursor position is marked by "<CURSOR>". Follow these steps:
                    1. Analyze the code context and the cursor position.
                    2. Provide your chain of thought reasoning, wrapped in <reasoning> tags. Include thoughts about the cursor position, what needs to be completed, and any necessary formatting.
                    3. Determine the appropriate code to complete the current thought, including finishing partial words or lines.
                    4. Replace "<CURSOR>" with the necessary code, ensuring proper formatting and line breaks.
                    5. Wrap your code solution in <answer> tags.
                    Your response should always include both the reasoning and the answer. Pay special attention to completing partial words or lines before adding new lines of code.
                    <examples>
                    <example>
                    User input:
                    --main.py--
                    # A function that reads in user inpu<CURSOR>
                    Response:
                    <reasoning>
                    1. The cursor is positioned after "inpu" in a comment describing a function that reads user input.
                    2. We need to complete the word "input" in the comment first.
                    3. After completing the comment, we should add a new line before defining the function.
                    4. The function should use Python's built-in `input()` function to read user input.
                    5. We'll name the function descriptively and include a return statement.
                    </reasoning>
                    <answer>
                    def read_user_input():
                        user_input = input("Enter your input: ")
                        return user_input
                    </answer>
                    </example>
                    <example>
                    User input:
                    --main.py--
                    def fibonacci(n):
                        if n <= 1:
                            return n
                        else:
                            re<CURSOR>
                    Response:
                    <reasoning>
                    1. The cursor is positioned after "re" in the 'else' clause of a recursive Fibonacci function.
                    2. We need to complete the return statement for the recursive case.
                    3. The "re" already present likely stands for "return", so we'll continue from there.
                    4. The Fibonacci sequence is the sum of the two preceding numbers.
                    5. We should return the sum of fibonacci(n-1) and fibonacci(n-2).
                    </reasoning>
                    <answer>turn fibonacci(n-1) + fibonacci(n-2)</answer>
                    </example>
                    </examples>
                  '';
                  messages = [
                    {
                      role = "user";
                      content = "{CODE}";
                    }
                  ];
                };
                post_process = {
                  extractor = "(?s)<answer>(.*?)</answer>";
                };
              }
              {
                action_display_name = "Refactor";
                model = "model1";
                parameters = {
                  max_context = 4096;
                  max_tokens = 1024;
                  system = ''
                    You are an AI coding assistant specializing in code refactoring. Your task is to analyze the given code snippet and provide a refactored version. Follow these steps:
                    1. Analyze the code context and structure.
                    2. Identify areas for improvement, such as code efficiency, readability, or adherence to best practices.
                    3. Provide your chain of thought reasoning, wrapped in <reasoning> tags. Include your analysis of the current code and explain your refactoring decisions.
                    4. Rewrite the entire code snippet with your refactoring applied.
                    5. Wrap your refactored code solution in <answer> tags.
                    Your response should always include both the reasoning and the refactored code.
                    <examples>
                    <example>
                    User input:
                    def calculate_total(items):
                        total = 0
                        for item in items:
                            total = total + item['price'] * item['quantity']
                        return total
                    Response:
                    <reasoning>
                    1. The function calculates the total cost of items based on price and quantity.
                    2. We can improve readability and efficiency by:
                       a. Using a more descriptive variable name for the total.
                       b. Utilizing the sum() function with a generator expression.
                       c. Using augmented assignment (+=) if we keep the for loop.
                    3. We'll implement the sum() function approach for conciseness.
                    4. We'll add a type hint for better code documentation.
                    </reasoning>
                    <answer>
                    from typing import List, Dict
                    def calculate_total(items: List[Dict[str, float]]) -> float:
                        return sum(item['price'] * item['quantity'] for item in items)
                    </answer>
                    </example>
                    <example>
                    User input:
                    def is_prime(n):
                        if n < 2:
                            return False
                        for i in range(2, n):
                            if n % i == 0:
                                return False
                        return True
                    Response:
                    <reasoning>
                    1. This function checks if a number is prime, but it's not efficient for large numbers.
                    2. We can improve it by:
                       a. Adding an early return for 2, the only even prime number.
                       b. Checking only odd numbers up to the square root of n.
                       c. Using a more efficient range (start at 3, step by 2).
                    3. We'll also add a type hint for better documentation.
                    4. The refactored version will be more efficient for larger numbers.
                    </reasoning>
                    <answer>
                    import math
                    def is_prime(n: int) -> bool:
                        if n < 2:
                            return False
                        if n == 2:
                            return True
                        if n % 2 == 0:
                            return False
                        
                        for i in range(3, int(math.sqrt(n)) + 1, 2):
                            if n % i == 0:
                                return False
                        return True
                    </answer>
                    </example>
                    </examples> 
                  '';
                  messages = [
                    {
                      role = "user";
                      content = "{SELECTED_TEXT}";
                    }
                  ];
                };
                post_process = {
                  extractor = "(?s)<answer>(.*?)</answer>";
                };
              }
            ];
          };
        };
      };
      language = [
        {
          name = "markdown";
          language-servers = [
            "lsp-ai"
          ];
        }
        {
          name = "cpp";
          auto-format = true;
          formatter = {
            command = "clang-format";
          };
          language-servers = [
            "clangd"
            "lsp-ai"
          ];
        }
        {
          name = "rust";
          auto-format = true;
          formatter = {
            command = "rustfmt";
          };
          language-servers = [
            "rust-analyzer"
            "lsp-ai"
          ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixfmt";
            args = [ "-" ];
          };
        }
        {
          name = "toml";
          auto-format = true;
          formatter = {
            command = "taplo";
            args = [
              "format"
              "-"
            ];
          };
        }
      ];
    };
  };
}
