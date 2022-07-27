// https://stackify.dev/940798-how-to-handle-unique-ptrs-with-swig

namespace std {
  %feature("novaluewrapper") unique_ptr;
  template <typename Type>
  struct unique_ptr {
     typedef Type* pointer;

     explicit unique_ptr( pointer Ptr );
     unique_ptr (unique_ptr&& Right);
     template<class Type2, Class Del2> unique_ptr( unique_ptr<Type2, Del2>&& Right );
     unique_ptr( const unique_ptr& Right) = delete;


     //pointer operator-> () const;
     pointer release ();
     void reset (pointer __p=pointer());
     void swap (unique_ptr &__u);
     pointer get () const;
     operator bool () const;

     ~unique_ptr();
  };
}

%define %wrap_unique_ptr(Name, Type)
  %template(Name) std::unique_ptr<Type>;
  %newobject std::unique_ptr<Type>::release;

  %typemap(out) std::unique_ptr<Type> %{
    $result = new $1_ltype(std::move($1));
  %}

  %typemap(memberin) std::unique_ptr<Type> %{
    $1 = std::move(*$input);
  %}


  %typemap(out) std::unique_ptr<Type> const %{
    $result = new $1_ltype(std::move($1));
  %}

%enddef