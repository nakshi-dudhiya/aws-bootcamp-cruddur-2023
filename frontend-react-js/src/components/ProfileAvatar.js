import './ProfileAvatar.css';

export default function ProfileAvatar(props) {
  const img = `url("https://assets.ncodes.ca/avatars/${props.id}.jpg")`;
  const styles= {
    backgroundImage: img,
    backgroundSize: 'cover',
    backgroundPosition: 'center'
  };
  
  return (
    <div className="profile-avatar" style={styles}></div>
  );
}