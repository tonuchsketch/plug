defmodule Plug.Conn.Adapter do
  @moduledoc """
  Specification of the connection adapter API implemented by webservers
  """
  alias Plug.Conn
  @typep payload :: term

  @doc """
  Sends the given status, headers and body as a response
  back to the client.

  If the request has method `"HEAD"`, the adapter should
  not send the response to the client.

  Webservers are advised to return `nil` as the sent_body,
  as the body can no longer be manipulated. However, the
  test implementation returns the actual body so it can
  be used during testing.
  """
  @callback send_resp(payload, Conn.status, Conn.headers, Conn.body) ::
              {:ok, sent_body :: binary | nil, payload}

  @doc """
  Sends the given status, headers and file as a response
  back to the client.

  If the request has method `"HEAD"`, the adapter should
  not send the response to the client.

  Webservers are advised to return `nil` as the sent_body,
  as the body can no longer be manipulated. However, the
  test implementation returns the actual body so it can
  be used during testing.
  """
  @callback send_file(payload, Conn.status, Conn.headers, file :: binary,
                        offset :: integer, length :: integer | :all) ::
              {:ok, sent_body :: binary | nil, payload}

  @doc """
  Sends the given status, headers as the beginning of
  a chunked response to the client.

  Webservers are advised to return `nil` as the sent_body,
  as the body can no longer be manipulated. However, the
  test implementation returns the actual body so it can
  be used during testing.
  """
  @callback send_chunked(payload, Conn.status, Conn.headers) ::
              {:ok, sent_body :: binary | nil, payload}

  @doc """
  Sends a chunk in the chunked response.

  If the request has method `"HEAD"`, the adapter should
  not send the response to the client.

  Webservers are advised to return `:ok` and not modify
  any further state for each chunk. However, the test
  implementation returns the actual body and payload so
  it can be used during testing.
  """
  @callback chunk(payload, Conn.status) ::
              :ok | {:ok, sent_body :: binary, payload} | {:error, term}

  @doc """
  Reads the request body.

  Read the docs in `Plug.Conn.read_body/2` for the supported
  options and expected behaviour.
  """
  @callback read_req_body(payload, options :: Keyword.t) ::
              {:ok, data :: binary, payload} |
              {:more, data :: binary, payload} |
              {:error, term}

  @doc """
  Push a resource to the client.

  If the adapter does not support server push then `{:error, :not_supported}`
  should be returned.
  """
  @callback push(payload, path :: String.t, headers :: Keyword.t) ::
              {:ok, payload} | {:error, term}
end
