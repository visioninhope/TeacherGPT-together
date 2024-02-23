import { Box, Button, Group, Textarea } from "@mantine/core";
import { useForm } from "@mantine/form";
import { useState } from "react";
import { Loading } from "../components/Loading/Loading";
import { Error } from "../components/Error";
import { ChatDisplay } from "../components/ChatDisplay";

type FormInput = {
  prompt: string;
};

export function GPTPage() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<null | string>(null);
  const [chatText, setChatText] = useState<null | string>(null);

  const form = useForm<FormInput>({
    initialValues: {
      prompt: "",
    },
    validate: {
      prompt: (value: string) =>
        value.length === 0 ? "Please type a prompt" : null,
    },
  });

  const handleSubmit = async (values: FormInput) => {
    setLoading(true);

    try {
        console.log(import.meta.env.VITE_CHATLOGIC_BASE_URL)
      console.log(values.prompt);
      setError(null);
      const response = await fetch(
        `http://${import.meta.env.VITE_CHATLOGIC_BASE_URL}/prompt`,
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ prompt: values.prompt }),
        }
      );

      if (response.status === 200) {
        const data = await response.text();
        setChatText(data);
      } else if (response.status === 429) {
        setError(
          "You've exceeded the rate limit. Please try again in a few minutes."
        );
      } else {
        setError("There was an error connecting to the AI server.");
      }
    } catch (error) {
      console.error("Error:", error);
      setError("Network error. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      GPTPage
      <Box>
        <form onSubmit={form.onSubmit(handleSubmit)}>
          <Textarea
            label="Type your question"
            description="Type a question for TeacherGPT"
            placeholder="What do you know about the student with the last name Bell?"
            {...form.getInputProps('prompt')} 
          />
          <Group>
            <Button type="submit" disabled={loading}>
              Submit Prompt
            </Button>
            {loading && <Loading />}
          </Group>
          {error && <Error error={error} onDismiss={() => setError(null)} />}
        </form>
      </Box>
      {chatText && <ChatDisplay data={chatText} />}
    </>
  );
}
